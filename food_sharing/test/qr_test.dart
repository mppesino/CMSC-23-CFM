import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mocktail/mocktail.dart';


import 'package:food_sharing/models/user.dart' as model; //to avoid Firebase conflict
import 'package:food_sharing/models/post.dart';
import 'package:food_sharing/provider/users_provider.dart';
import 'package:food_sharing/provider/posts_provider.dart';
import 'package:food_sharing/screen/subpages/post_detail.dart';

class MockUsersProvider extends Mock implements UsersProvider {}
class MockPostsProvider extends Mock implements PostsProvider {}

void main() {
  //Mocktail requires fallback values for custom enums or types if used with any()
  setUpAll(() {
    registerFallbackValue(PostStatus.completed);
  });

  testWidgets('Should complete transaction when QR code matches', (WidgetTester tester) async {
    final mockPostsProvider = MockPostsProvider();
    final mockUsersProvider = MockUsersProvider();

    final dummyGiver = model.User(
      userId: 'sampleid',
      email: 'email@email.com',
      firstName: 'Christian',
      lastName: 'Ebalobo',
      userName: 'vash',
      bio: 'description',
      profilePicture: '',
      isVerified: true,
      isOnboarded: true,
      tags: [],
    );

    final dummyRequester = model.User(
      userId: 'idsample', 
      email: 'requester@email.com', 
      firstName: 'requester', 
      lastName: 'req', 
      userName: 'reqer', 
      isOnboarded: true, 
      isVerified: true
    );

    final dummyPost = Post(
      id: 'test_post_123',
      title: 'Extra Adobo',
      userId: 'sampleid',
      reservedForId: 'idsample',
      description: 'Fresh, refrigerated',
      status: PostStatus.reserved,
      expiration: DateTime.now().add(const Duration(days: 1)),
      pickupDateTime: DateTime.now(),
      pickupAddress: 'Vega',
      tags: [],

      postLat: 1,
      postLng: 1
    );

    
    when(() => mockUsersProvider.getUserById('sampleid')).thenAnswer((_) async => dummyGiver);
    when(() => mockUsersProvider.getUserById('idsample')).thenAnswer((_) async => dummyRequester);
    //current logged-in test user must be the requester to see "Scan QR"
    when(() => mockUsersProvider.currentUser).thenReturn(dummyRequester);

    when(() => mockPostsProvider.updatePostStatus(any(), any())).thenAnswer((_) async{});

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<PostsProvider>.value(value: mockPostsProvider),
          ChangeNotifierProvider<UsersProvider>.value(value: mockUsersProvider),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: PostDetailPage(post: dummyPost),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    //tap the button and verify
    final Finder scanButton = find.textContaining('Scan QR');
    expect(scanButton, findsOneWidget);
    
    //ensure button is scrolled into view before tapping:
    await tester.ensureVisible(scanButton);
    await tester.pumpAndSettle();

    //1. tap button:
    await tester.tap(scanButton);

    //2. pump a single frame to let the navigator register and open the QRScanner route
    await tester.pump();

    //3. simulate a successful scan:
    Navigator.of(tester.element(scanButton)).pop(true);

    //4. let the pop animation complete and execute the code below
    await tester.pumpAndSettle();

    //verify method invocation using mocktail syntax
    verify(() => mockPostsProvider.updatePostStatus('test_post_123', PostStatus.completed)).called(1);
  });
}