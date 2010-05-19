From: tristan <tristan.ye@oracle.com>
Date: Wed, 19 May 2010 12:15:00 +0800
Subject: [Ocfs2-devel] [PATCH 4/4] Ocfs2: Optimize punching-hole codes
 v5.
In-Reply-To: <20100518190348.GK20644@wotan.suse.de>
References: <1273571685-28000-1-git-send-email-tristan.ye@oracle.com>
	<1273571685-28000-5-git-send-email-tristan.ye@oracle.com>
	<20100518190348.GK20644@wotan.suse.de>
Message-ID: <4BF365C4.8080908@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mark Fasheh wrote:
> On Tue, May 11, 2010 at 05:54:45PM +0800, Tristan Ye wrote:
>> V5 patch simplifies the logic of handling existing holes and procedures
>> for skipping extent blocks, and removed most of confusing comments.
>>
>> V5 patch has survived with fill_verify_holes testcase in ocfs2-test,
>> it also passed my manual sanity check and stress tests with enormous
>> extent records.
>
> Ok, this looks good too.
>
>
>> Currently punching hole on a file with 3+ extent tree depth was
>> really a performance disaster, it even caused several hours to
>> go, though we may not hit this in real life with such a huge extent
>> number.
>>
>> One simple way to improve the performance is quite straightforward,
>> by learning the logic of truncating codes, means we'd punch hole from
>> hole_end to hole_start, which reduce the overhead of btree operation
>> in a significant way, such as tree rotation and moving.
>
> Right, so by punching from right to left, we're optimizing away rotations
> for at least those calls which are asking for a hole at the tail of the
> file. What is the performance change if we consider the other cases
> (punching in the middle or beginning of a file) only?

Mark,

Let me show you my latest benchmark statistics, say we're going to 
operate on a 1G file, with 1G/4k extent recs(clustersize = 4k, each 
cluster takes a ext record):

1. punching hole from begin to end:
# time ./punch_hole -f /storage/testfile -s 0 -l 1073741824

================ statistics with v5 patch =================
real 0m0.856s
user 0m0.000s
sys 0m0.855s
=========================== end ===========================

=============== statistics without v5 patch ===============
real 0m16.545s
user 0m0.001s
sys 0m15.704s
=========================== end ===========================

2. punching hole from begin to middle:
# time ./punch_hole -f /storage/testfile -s 0 -l 536870912

================ statistics with v5 patch =================
real 0m8.004s
user 0m0.000s
sys 0m7.960s
=========================== end ===========================

=============== statistics without v5 patch ===============
real 0m11.808s
user 0m0.000s
sys 0m11.786s
=========================== end ===========================

3. punching hole from middle to end:
./punch_hole -f /storage/testfile -s 536870912 -l 536870912

================ statistics with v5 patch =================
real 0m0.433s
user 0m0.000s
sys 0m0.433s
=========================== end ===========================

=============== statistics without v5 patch ===============
real 0m4.255s
user 0m0.000s
sys 0m4.249s
=========================== end ===========================


Patches are going to pay off when number of extent records was large 
enough, and its performance gain increases sharply as extent record grows.

>
>
> Code-wise everything looks sane. I won't lie - it helps me to be comfortable
> the changes knowing that you tested regularly with our tools  ;)

Definitely, regular testcases in ocfs2-test.git all have been tried out, 
besides, with a combined test with reflink.

What's more, many boundary and manual testcases also get passed on my 
hand as I can imagine.

>
> Signed-off-by: Mark Fasheh <mfasheh@suse.com>
> 	--Mark
>
> --
> Mark Fasheh
