From: Andrew Beekhof <abeekhof@suse.de>
Date: Tue, 18 Nov 2008 11:30:18 +0100
Subject: [Ocfs2-devel] New OCF edition of o2cb
Message-ID: <02292B9D-C88D-4262-AADF-3820512DC60E@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

Here is an OCF-compliant edition of o2cb for use by cluster managers  
to control userspace-based OCFS2 installations.
It defaults to using the pcmk stack, but can also be configured to use  
cman.

I believe the correct location for it is vendor/common

Oh, and if the license is an issue, it can be changed.

Andrew

-------------- next part --------------
A non-text attachment was scrubbed...
Name: o2cb.ocf.sh
Type: application/octet-stream
Size: 11056 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20081118/9c3e6005/attachment.obj 
