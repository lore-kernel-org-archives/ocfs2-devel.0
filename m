From: Andrew Beekhof <beekhof@gmail.com>
Date: Wed, 4 Mar 2009 09:21:48 +0100
Subject: [Ocfs2-devel] Patch to Pacemaker hooks in ocfs2_controld
Message-ID: <D8579235-5640-43E5-9B8D-F9B469021ABE@gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Guys,

I overhauled and simplified the Pacemaker hooks recently.  This patch:
- Reuses more code from the Pacemaker libraries
- Escalates fencing to the cluster manager instead of initiating it  
directly

Attached patch is against master, or you can pull the original patch  
which is against an older version used by SUSE:
   http://git.clusterlabs.org/?p=ocfs2-tools.git;a=commit;h=dfc25180085c160baff412eb7423c6285cb166a9

regards,
Andrew


-------------- next part --------------
A non-text attachment was scrubbed...
Name: pacemaker-hooks.patch
Type: application/octet-stream
Size: 12632 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20090304/1d9b521a/attachment.obj 
-------------- next part --------------
