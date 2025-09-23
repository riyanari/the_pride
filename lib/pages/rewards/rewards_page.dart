import 'package:flutter/material.dart';
import 'package:the_pride/pages/rewards/detail_reward_page.dart';
import 'package:the_pride/pages/rewards/widgets/favorite_reward_tail.dart';
import 'package:the_pride/pages/rewards/widgets/reward_tail.dart';

import '../../data/dummy_reward.dart';
import '../../theme/theme.dart';

class RewardsPage extends StatefulWidget {
  const RewardsPage({super.key});

  @override
  State<RewardsPage> createState() => _RewardsPageState();
}

class _RewardsPageState extends State<RewardsPage> {
  String _sortType = "lowest"; // default: dari poin terendah

  List getSortedRewards() {
    final rewards = [...dummyRewards]; // copy biar list asli ga berubah
    if (_sortType == "lowest") {
      rewards.sort((a, b) => a.points.compareTo(b.points));
    } else {
      rewards.sort((a, b) => b.points.compareTo(a.points));
    }
    return rewards;
  }

  Widget favoriteReward() {
    final topRewards = dummyRewards..sort((a, b) => b.sold.compareTo(a.sold));
    final favoriteTop5 = topRewards.take(5).toList();

    return Padding(
      padding: const EdgeInsets.fromLTRB(18.0, 30, 18, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Favorite Reward",
            style: primaryTextStyle.copyWith(fontSize: 16, fontWeight: medium),
          ),
          const SizedBox(height: 18),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            clipBehavior: Clip.none,
            child: Row(
              children: favoriteTop5
                  .map(
                    (reward) => Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetailRewardPage(reward: reward),
                            ),
                          );
                        },
                        child: FavoriteRewardTail(reward: reward),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget allRewards() {
    final sortedRewards = getSortedRewards();

    return Padding(
      padding: const EdgeInsets.fromLTRB(18.0, 0, 18, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "All Rewards",
                style: primaryTextStyle.copyWith(
                  fontSize: 16,
                  fontWeight: medium,
                ),
              ),
              DropdownButton<String>(
                value: _sortType,
                items: const [
                  DropdownMenuItem(
                    value: "lowest",
                    child: Text("Dari poin terendah"),
                  ),
                  DropdownMenuItem(
                    value: "highest",
                    child: Text("Dari poin tertinggi"),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _sortType = value!;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 18),

          // List reward
          Column(
            children: sortedRewards
                .map(
                  (reward) => Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailRewardPage(reward: reward),
                          ),
                        );
                      },
                      child: RewardTail(reward: reward),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(children: [favoriteReward(), allRewards()]),
        ),
      ),
    );
  }
}
