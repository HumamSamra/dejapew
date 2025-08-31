// ignore_for_file: non_constant_identifier_names, no_leading_underscores_for_local_identifiers

part of 'game_session.imports.dart';

class GameSessionScreen extends StatefulWidget {
  final DifficultyLevel level;
  final GameType gameType;
  final CardsType cardsType;
  const GameSessionScreen({
    super.key,
    required this.level,
    required this.gameType,
    required this.cardsType,
  });

  @override
  State<GameSessionScreen> createState() => _GameSessionScreenState();
}

class _GameSessionScreenState extends State<GameSessionScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController _controller;
  late AnimationController _confetteController;
  late AnimationController _pauseController;
  int showAnimation = 1;
  int showMenuAnimation = 1;
  bool show1 = false, show2 = false;

  String? p1Name, p2Name, winner;
  List<GameCard> cards = [];
  List<GameCard> chosenCards = [];
  int p1Score = 0;
  int p2Score = 0;
  ComputerAgent? bot;
  late Duration _remaining;
  Duration _turnRemaning = Duration(minutes: 0, seconds: 30);
  PlayerTurn playerTurn = PlayerTurn.PLAYER1;

  Timer? _timer;
  bool _isPaused = false;
  bool canFlip = true;
  bool gameFinished = false;

  @override
  void initState() {
    _remaining = Duration(
      minutes: widget.level == DifficultyLevel.easy
          ? 4
          : widget.level == DifficultyLevel.normal
          ? 6
          : 8,
    );

    p1Name = widget.gameType == GameType.against_bot ? 'انت' : 'اللاعب 1';
    p2Name = widget.gameType == GameType.against_bot ? 'الكمبيوتر' : 'اللاعب 2';

    if (widget.gameType == GameType.against_bot) {
      bot = ComputerAgent(level: widget.level, memory: []);
    }

    WidgetsBinding.instance.addObserver(this);
    _controller = AnimationController(vsync: this);
    _confetteController = AnimationController(vsync: this);
    _pauseController = AnimationController(vsync: this);

    super.initState();
    _initCards();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _pauseTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    _pauseController.dispose();
    _confetteController.dispose();
    SoundManager.player.stop();
    super.dispose();
  }

  _initCards() {
    final totalCards = widget.level == DifficultyLevel.easy
        ? 20
        : widget.level == DifficultyLevel.normal
        ? 30
        : 48;
    final tmp = <GameCard>[];
    for (int i = 1; i <= 24; i++) {
      tmp.add(GameCard('assets/game_cards/${widget.cardsType.name}/$i.png'));
    }

    tmp.shuffle();
    final tempCards = tmp.take((totalCards / 2).toInt());
    for (final item in tempCards) {
      cards.add(
        GameCard(item.path)
          ..id = Uuid().v1()
          ..controller = FlipCardController()
          ..key = UniqueKey(),
      );
      cards.add(
        GameCard(item.path)
          ..id = Uuid().v1()
          ..controller = FlipCardController()
          ..key = UniqueKey(),
      );
    }
    cards.shuffle();

    setState(() {});
  }

  void _startTimer() async {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (_remaining.inSeconds > 0) {
        if (!_isPaused) {
          _remaining = Duration(seconds: _remaining.inSeconds - 1);

          if (_turnRemaning.inSeconds > 0) {
            _turnRemaning = Duration(seconds: _turnRemaning.inSeconds - 1);
          } else {
            if (playerTurn == PlayerTurn.PLAYER1) {
              playerTurn = PlayerTurn.PLAYER2;
            } else {
              playerTurn = PlayerTurn.PLAYER1;
            }
            chosenCards.clear();
            flipAllCardsBack();
            _turnRemaning = Duration(seconds: 30);
            SoundManager.playSound(SoundKeys.changeTurn);
          }
          setState(() {});

          if (widget.gameType == GameType.against_bot &&
              !bot!.isPlaying &&
              playerTurn == PlayerTurn.PLAYER2 &&
              chosenCards.isEmpty) {
            final rng = Random();
            bot!.isPlaying = true;

            await Future.delayed(Duration(seconds: rng.nextInt(3)));
            var memoryCards = <GameCard>[];
            if (bot!.hasSufficientCards) {
              memoryCards = bot!.chooseCardsFromMemory();
            } else {
              final availableCards = cards.where((e) => !e.keepValue).toList();
              final card_1 = availableCards[rng.nextInt(availableCards.length)];
              availableCards.remove(card_1);
              memoryCards.add(card_1);
              memoryCards.add(
                availableCards[rng.nextInt(availableCards.length)],
              );
            }

            memoryCards[0].controller!.toggleCard();
            SoundManager.playSound(SoundKeys.flipCard);
            // First Card Prediction

            await Future.delayed(Duration(seconds: rng.nextInt(3)));
            // Second Card Prediction
            memoryCards[1].controller!.toggleCard();
            SoundManager.playSound(SoundKeys.flipCard);
            bot!.isPlaying = false;
          }
        }
      } else {
        _timer?.cancel();
        winner = p1Score > p2Score
            ? p1Name
            : p1Score == p2Score
            ? 'تعادل'
            : p2Name;
        await Future.delayed(Duration(seconds: 1));
        setState(() {
          gameFinished = true;
        });
        SoundManager.playSound(SoundKeys.win, lowLatency: false);
        await Future.delayed(const Duration(milliseconds: 500));
        setState(() => show1 = true);
        await Future.delayed(const Duration(milliseconds: 500));
        setState(() => show2 = true);
      }
    });
  }

  void _pauseTimer() {
    if (_timer != null && _timer!.isActive) {
      setState(() {
        showMenuAnimation = 2;
        _isPaused = true;
      });
    }
  }

  void _resumeTimer() {
    if (_isPaused) {
      setState(() {
        _isPaused = false;
      });
    }
  }

  void chooseCards(GameCard card_1, GameCard card_2) {
    cards
        .where((e) => e.id == chosenCards[0].id || e.id == chosenCards[1].id)
        .forEach((e) => e.keepValue = true);
    _turnRemaning = Duration(seconds: 30);
    setState(() {});
  }

  void flipAllCardsBack() {
    cards
        .where((e) => !e.controller!.state!.isFront && !e.keepValue)
        .forEach((e) => e.controller!.toggleCard());
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          if (_isPaused) {
            _resumeTimer();
          } else {
            SoundManager.playSound(SoundKeys.click);
            if (context.mounted) {
              _leaveWarning();
            }
          }
        }
      },
      child: AppScaffold(
        child: Stack(
          children: [
            BackgroundPattern(
              pattern: BgPatternType.topography,
              children: [
                AppTopbar(
                  title: Utils.formatTime(_remaining),
                  trailing: _isPaused
                      ? Icons.play_arrow_rounded
                      : Icons.pause_rounded,
                  trailingOnTap: () async {
                    SoundManager.playSound(SoundKeys.click);
                    if (context.mounted) {
                      if (_isPaused) {
                        _resumeTimer();
                      } else {
                        _pauseTimer();
                      }
                    }
                  },
                  leading: Icons.arrow_back,
                  leadingOnTap: () async {
                    if (context.mounted) {
                      _leaveWarning();
                    }
                  },
                ),
                Gap(20),
                PlayerTile(
                  playerName: p1Name ?? '',
                  score: p1Score,
                  remaining: playerTurn == PlayerTurn.PLAYER1
                      ? _turnRemaning
                      : null,
                  playerTurn: playerTurn == PlayerTurn.PLAYER1,
                ),
                PlayerTile(
                  playerName: p2Name ?? '',
                  score: p2Score,
                  remaining: playerTurn == PlayerTurn.PLAYER2
                      ? _turnRemaning
                      : null,
                  playerTurn: playerTurn == PlayerTurn.PLAYER2,
                ),

                Spacer(),
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(15.0),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: widget.level == DifficultyLevel.easy
                          ? 5
                          : widget.level == DifficultyLevel.normal
                          ? 6
                          : 8,
                      crossAxisSpacing: 3,
                      mainAxisSpacing: 3,
                      childAspectRatio: 2 / 3,
                    ),
                    itemCount: widget.level == DifficultyLevel.easy
                        ? 20
                        : widget.level == DifficultyLevel.normal
                        ? 30
                        : 48,
                    itemBuilder: (context, index) {
                      final item = cards[index];
                      final _flip = item.controller!;

                      return GestureDetector(
                        onTap: () => _handleCardTap(item),
                        child: FlipCard(
                          key: item.key,
                          controller: _flip,
                          flipOnTouch: false,
                          onFlip: () => _handleCardFlip(item),
                          back: Card(
                            color: AppColors.accent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(5),
                              child: Image(image: AssetImage(item.path)),
                            ),
                          ),
                          front: Card(
                            color: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(10),
                              child: Image(
                                colorBlendMode: BlendMode.srcIn,
                                color: AppColors.light,
                                filterQuality: FilterQuality.high,
                                image: Svg(
                                  'assets/brand/logo.svg',
                                  size: Size(50, 50),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Spacer(),
                Text(
                  "v1.0",
                  style: TextStyle(fontSize: 25, color: AppColors.light),
                ),
              ],
            ),

            // Confette animation
            ConfetteAnimation(controller: _confetteController),

            if (showAnimation != 3)
              StartAnimation(
                animationState: showAnimation,
                onEnd: () => setState(() {
                  showAnimation = 3;
                }),
                onLoaded: (composition) {
                  _controller
                    ..duration = composition.duration
                    ..forward().whenComplete(() {
                      setState(() {
                        showAnimation = 2;
                      });
                      _startTimer();
                    });
                },
              ),

            if (gameFinished)
              EndMenu(
                show1: show1,
                show2: show2,
                p1Score: p1Score,
                p2Score: p2Score,
                winner: winner ?? '',
                onBack: () => _leaveWarning(),
                onrestart: () => _restartWarning(),
              ),

            if (showMenuAnimation == 2)
              PauseMenu(
                isPaused: _isPaused,
                showAnimation: showMenuAnimation,
                onEnd: () => setState(() {
                  showMenuAnimation = 1;
                }),
                onContinue: () {
                  showMenuAnimation = 1;
                  _resumeTimer();
                },
                onrestart: () => _restartWarning(),
                onExit: () => _leaveWarning(),
              ),
          ],
        ),
      ),
    );
  }

  void _restartWarning() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AppDialog(
          title: 'هل انت متأكد؟',
          text:
              'سيتم إعادة هذه المباراة و عدم احتسابها، هل انت متأكد انك تريد الخروج؟',
          mainTitle: 'تأكيد',
          subTitle: 'إلغاء',
          onMain: () {
            Navigator.pop(context);
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) =>
                    GameSessionScreen(
                      level: widget.level,
                      gameType: widget.gameType,
                      cardsType: widget.cardsType,
                    ),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          },
          onSub: () => Navigator.pop(context),
        );
      },
    );
  }

  void _leaveWarning() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AppDialog(
          title: 'هل انت متأكد؟',
          text:
              'سيتم إلغاء هذه المباراة و عدم احتسابها، هل انت متأكد انك تريد الخروج؟',
          mainTitle: 'تأكيد',
          subTitle: 'إلغاء',
          onMain: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
          onSub: () => Navigator.pop(context),
        );
      },
    );
  }

  void _handleCardFlip(GameCard item) async {
    if (!context.mounted ||
        chosenCards.length >= 2 ||
        !canFlip ||
        !item.controller!.state!.isFront) {
      return;
    }

    setState(() {
      canFlip = false;
    });

    chosenCards.add(item);
    if (chosenCards.length >= 2) {
      if (chosenCards[0].path != chosenCards[1].path) {
        await Future.delayed(Duration(seconds: 1));
        if (context.mounted) {
          flipAllCardsBack();
        }

        if (playerTurn == PlayerTurn.PLAYER1) {
          playerTurn = PlayerTurn.PLAYER2;
        } else {
          playerTurn = PlayerTurn.PLAYER1;
        }
        SoundManager.playSound(SoundKeys.changeTurn);

        if (widget.gameType == GameType.against_bot) {
          bot!.memorizeCard(chosenCards[0]);
          bot!.memorizeCard(chosenCards[1]);
        }

        _turnRemaning = Duration(seconds: 30);
      } else {
        chooseCards(chosenCards[0], chosenCards[1]);
        if (playerTurn == PlayerTurn.PLAYER1) {
          p1Score += 1;
        } else {
          p2Score += 1;
        }
        SoundManager.playSound(SoundKeys.correct);
        await Future.delayed(Duration(milliseconds: 500));
        _confetteController
          ..reset()
          ..forward();

        if (widget.gameType == GameType.against_bot &&
            bot!.memory.any((e) => e.path == chosenCards[0].path)) {
          bot!.memory.removeWhere((e) => e.path == chosenCards[0].path);
        }
      }
      chosenCards.clear();

      if (!cards.any((e) => !e.keepValue)) {
        _timer?.cancel();
        winner = p1Score > p2Score
            ? p1Name
            : p1Score == p2Score
            ? 'تعادل'
            : p2Name;
        await Future.delayed(Duration(seconds: 1));
        setState(() {
          gameFinished = true;
        });
        SoundManager.playSound(SoundKeys.win);
        await Future.delayed(const Duration(milliseconds: 500));
        setState(() => show1 = true);
        await Future.delayed(const Duration(milliseconds: 500));
        setState(() => show2 = true);
      }
    }

    canFlip = true;
    setState(() {});
  }

  void _handleCardTap(GameCard card) async {
    final _flip = card.controller!;
    if (gameFinished ||
        !canFlip ||
        (playerTurn == PlayerTurn.PLAYER2 &&
            widget.gameType == GameType.against_bot)) {
      return; // block taps if not allowed
    }
    if ((_flip.state?.isFront ?? false) &&
        chosenCards.length < 2 &&
        !chosenCards.any((e) => e.id == card.id) &&
        !card.keepValue &&
        (!chosenCards.any((e) => e.id == card.id))) {
      SoundManager.playSound(SoundKeys.flipCard);
      _flip.toggleCard();
    }
  }
}
