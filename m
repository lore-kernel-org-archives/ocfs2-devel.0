From: tristan <tristan.ye@ORACLE.COM>
Date: Wed, 07 Jul 2010 09:16:44 +0800
Subject: [Ocfs2-devel] [PATCH] tailtest: Add a test for the tail zeroing
 bug
In-Reply-To: <20100706120254.GH13023@mail.oracle.com>
References: <20100702223924.GB5800@mail.oracle.com>
	<4C32DF2E.3050803@oracle.com>
	<20100706120254.GH13023@mail.oracle.com>
Message-ID: <4C33D57C.8060607@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Signed-off-by: Tristan Ye <tristan.ye@oracle.com>

Joel Becker wrote:
> On Tue, Jul 06, 2010 at 03:45:50PM +0800, tristan wrote:
>> Hi Joel,
>>
>> I'm totally trusting the logic of your testcase to test tail zeroing.
>>
>> Just two concerns as follows:
>>
>> 1. It should be better to make the script runnable for none-privilege 
>> users for the sake of security concerns.
>
> 	Can't mount without root privileges, and the test requires
> umount/mount cycles to expose the problem.  I wish I had a better
> answer too.
>
>> 2. Why not make variations with different bs and cs combinations
>
> 	This is a good idea for completeness, but I don't want to spend
> the time on that right now.  I picked a bs/cs combination that was sure
> to expose the bug as we know it.
>
>>> +cleanup()
>>> +{
>>> +    [ -d "$_MOUNTPOINT" ] && umount "$_MOUNTPOINT"
>>> +    [ -d "$_MOUNTPOINT" ] && rmdir "$_MOUNTPOINT"
>>> +    [ -n "$_LOOP" ] && losetup -d "$_LOOP"
>>> +    [ -n "$_IMAGE" ] && rm -f "$_IMAGE"
>> You may also need to cleanup expected template files for comparison? if 
>> the test aborts abnormally.
>
> 	The template files are on the test filesystem.  They go away
> when we remove the image.
>
>> or rmdir never succeeds. I guess using "rm -rf $MOUNTPOINT" here will be 
>> more aggressive to handle this.
>
> 	There's nothing under the mountpoint after we've unmounted.
> that's why I use rmdir and not rm -rf.
>
> Joel
>
