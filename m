From: Villalovos, John L <john.l.villalovos@intel.com>
Date: Wed Mar 24 20:33:44 2004
Subject: [Ocfs2-devel] Patch to fix error if mount fails
Message-ID: <60C14C611F1DDD4198D53F2F43D8CA3B0E3E2E@orsmsx410.jf.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mark Fasheh wrote:
> On Tue, Mar 23, 2004 at 10:29:55AM -0800, John L. Villalovos wrote:
>> I had an issue where if the mount failed after the threads had
>> started that the thread would crash later on.
> Do you have any more info on the crash? I'd be interested in what
> the NM thread did to kill itself... Or is this that bug where
> one of the
> devices fields on a bh was not set?

Yes it was the one in the message titled:
Crash in ocfs_volume_thread

The NULL pointer is in bh->b_bdev.


>> This patch makes sure that the NM thread is terminated if the mount
>> fails and the thread has been started.
>> 
>> I didn't really see an easy way to terminate the listener thread :(
> Well, it's supposed to be happening in ocfs_dismount_volume,
> which *does*
> get called if ocfs_mount_volume returns an error. Why isn't
> it happening
> there? Is it because "osb->dlm_task" hasn't been set yet?

I'm not sure??  I just noticed that when I did a "ps ax" I saw an
ocfs2lsnr (or something like that) running.  This was after the mount
failed.

John
