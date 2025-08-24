// ignore_for_file: non_constant_identifier_names, no_leading_underscores_for_local_identifiers

part of 'game_session.imports.dart';

class GameSessionScreen extends StatefulWidget {
  final DifficultyLevel level;
  const GameSessionScreen({super.key, required this.level});

  @override
  State<GameSessionScreen> createState() => _GameSessionScreenState();
}

class _GameSessionScreenState extends State<GameSessionScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController _controller;
  List<GameCard> cards = [];
  List<GameCard> chosenCards = [];
  int showAnimation = 1;
  int showMenuAnimation = 1;
  PlayerTurn playerTurn = PlayerTurn.PLAYER1;
  Timer? _timer;
  bool _isPaused = false;
  bool canFlip = true;
  Duration _remaining = const Duration(minutes: 5);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller = AnimationController(vsync: this);
    _initCards();
  }

  _initCards() {
    final totalCards = widget.level == DifficultyLevel.easy
        ? 20
        : widget.level == DifficultyLevel.normal
        ? 30
        : 48;
    final tmp = <GameCard>[];
    for (int i = 1; i <= 24; i++) {
      tmp.add(GameCard('assets/game_cards/ios_emojies/$i.png'));
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

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remaining.inSeconds > 0 && !_isPaused) {
        setState(() {
          _remaining = Duration(seconds: _remaining.inSeconds - 1);
        });
      } else {
        _timer?.cancel();
        // Match Ends
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _pauseTimer();
    } else if (state == AppLifecycleState.resumed && _isPaused) {
      _resumeTimer();
    }
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
        _startTimer();
      });
    }
  }

  String _formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final minutes = twoDigits(duration.inMinutes);
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
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
            await _leaveWarning();
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
                  title: _formatTime(_remaining),
                  trailing: _isPaused
                      ? Icons.play_arrow_rounded
                      : Icons.pause_rounded,
                  trailingOnTap: () {
                    if (_isPaused) {
                      _resumeTimer();
                    } else {
                      _pauseTimer();
                    }
                  },
                  leading: Icons.arrow_back,
                  leadingOnTap: () async => await _leaveWarning(),
                ),
                Gap(40),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: ListTile(
                    title: Text(
                      'اللاعب 1',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 30, color: AppColors.light),
                    ),
                    trailing: Text(
                      '(دورك)',
                      style: TextStyle(color: AppColors.primary, fontSize: 20),
                    ),
                  ),
                ),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: ListTile(
                    title: Text(
                      'اللاعب 2',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 30, color: AppColors.light),
                    ),
                    trailing: Text(
                      '(انتظر دورك)',
                      style: TextStyle(color: AppColors.gray, fontSize: 20),
                    ),
                  ),
                ),
                Spacer(),
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(15.0),
                  child: GridView.builder(
                    shrinkWrap: true, // important if inside Column
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: widget.level == DifficultyLevel.easy
                          ? 5
                          : widget.level == DifficultyLevel.normal
                          ? 6
                          : 8,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
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

                      return GridAnimatorWidget(
                        child: GestureDetector(
                          onTap: () {
                            if (!canFlip) return; // block taps if not allowed
                            if ((_flip.state?.isFront ?? false) &&
                                chosenCards.length < 2 &&
                                !chosenCards.any((e) => e.id == item.id)) {
                              _flip.toggleCard();
                            }
                          },
                          child: FlipCard(
                            key: item.key,
                            controller: _flip,
                            flipOnTouch: false,
                            onFlip: () async {
                              if (chosenCards.length >= 2 || !canFlip) {
                                return;
                              }
                              setState(() {
                                canFlip = false;
                              });
                              chosenCards.add(item);
                              if (chosenCards.length >= 2) {
                                await Future.delayed(Duration(seconds: 1));
                                if (chosenCards[0].path !=
                                    chosenCards[1].path) {
                                  if (context.mounted) {
                                    cards
                                        .where(
                                          (e) =>
                                              !e.controller!.state!.isFront &&
                                              !e.keepValue,
                                        )
                                        .forEach(
                                          (e) => e.controller!.toggleCard(),
                                        );
                                  }
                                } else {
                                  cards
                                      .where(
                                        (e) =>
                                            e.id == chosenCards[0].id ||
                                            e.id == chosenCards[1].id,
                                      )
                                      .forEach((e) => e.keepValue = true);
                                }
                                chosenCards.clear();
                              }
                              canFlip = true;
                              setState(() {});
                            },
                            back: Card(
                              color: AppColors.accent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(10),
                                child: Image(
                                  height: 50,
                                  width: 50,
                                  image: AssetImage(item.path),
                                ),
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
            if (showAnimation != 3)
              // 3 2 1 screen
              AnimatedOpacity(
                opacity: showAnimation == 1 ? 1 : 0,
                duration: Duration(milliseconds: 300),
                onEnd: () => setState(() {
                  showAnimation = 3;
                }),
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: AppColors.black.withAlpha(50),
                  alignment: Alignment.center,
                  child: Lottie.asset(
                    'assets/lottie/countdown.json',
                    repeat: false,
                    onLoaded: (composition) {
                      _controller
                        ..duration = composition.duration
                        ..forward().whenComplete(() {
                          setState(() {
                            showAnimation = 2;
                            _startTimer();
                          });
                        });
                    },
                  ),
                ),
              ),

            if (showMenuAnimation == 2)
              AnimatedOpacity(
                duration: Duration(milliseconds: 400),
                opacity: _isPaused ? 1 : 0,
                onEnd: () => setState(() {
                  showMenuAnimation = 1;
                }),
                child: Container(
                  color: AppColors.black.withAlpha(200),
                  height: MediaQuery.sizeOf(context).height,
                  width: MediaQuery.sizeOf(context).width,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.pause_rounded,
                          size: 150,
                          color: AppColors.darklight,
                        ),
                        Text(
                          'تم إيقاف اللعبة',
                          style: TextStyle(
                            fontSize: 25,
                            color: AppColors.darklight,
                          ),
                        ),
                        Gap(20),
                        HomeMainBtn(
                          title: 'إستئناف',
                          onTap: () {
                            _resumeTimer();
                          },
                        ),
                        Gap(20),
                        HomeOutlineBtn(title: 'إعادة المباراة', onTap: () {}),
                        Gap(20),
                        HomeOutlineBtn(
                          title: 'خروج',
                          onTap: () => _leaveWarning(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  _leaveWarning() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.background,
          title: Text(
            'هل انت متأكد؟',
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 25, color: AppColors.light),
          ),
          content: Text(
            'سيتم إلغاء هذه المباراة و عدم احتسابها، هل انت متأكد انك تريد الخروج؟',
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 18, color: AppColors.light),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                foregroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text('إلغاء', style: TextStyle(fontSize: 18)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.light,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text('تأكيد', style: TextStyle(fontSize: 18)),
            ),
          ],
        );
      },
    );
  }
}
