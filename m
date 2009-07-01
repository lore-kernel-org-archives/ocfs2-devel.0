From: sylarrrrrrr at aim.com <sylarrrrrrr@aim.com>
Date: Wed, 01 Jul 2009 07:31:44 -0400
Subject: [Ocfs2-devel] mounting a snapshot for backup.
Message-ID: <8CBC856A56D83A0-16F0-2692@FWM-M16.sysops.aol.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


Hi



I have an ocfs2 volume (1.4.1) on lvm2, which is made available on 2 nodes via dual primary drbd that is on it. I wanted to backup my volume, so naturally I made a snapshot of it via the lvm2, and tried to mount it for backing up. However, I got the following error in dmesg :



[319981.478168] (23483,0):ocfs2_fill_super:700 ERROR: Unable to create per-mount debugfs root.



I then searched a bit, and found that ocfs2 can't mount an already mounted volume, and I was suggested to change the UUID of the snapshot device in order to be able to mount it.



So I tried using tunefs.ocfs2 and got the following error:



tunefs.ocfs2 1.4.1
tunefs.ocfs2: Trylock failed while locking down the cluster

So I searched a bit and found that there was a patch suggestion for ?--force option to tunefs,




http://oss.oracle.com/pipermail/ocfs2-devel/2008-July/002447.html



and that it was rejected,



http://oss.oracle.com/pipermail/ocfs2-devel/2008-July/002449.html



and some ominous warnings,



http://oss.oracle.com/pipermail/ocfs2-devel/2008-July/002450.html





o well... now how am I supposed to backup my live ocfs2 volume? Make a virtual machine that will have just that snapshot device?




-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20090701/3ceba5f8/attachment.html 
