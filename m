From: nagius at astek.fr <nagius@astek.fr>
Date: Thu, 09 Dec 2010 10:11:43 +0100
Subject: [Ocfs2-devel] [PATCH] Call userspace script when self-fencing
Message-ID: <20101209101143.4niwmlbyjccc0444@webmail.astek.fr>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



   Hi,

According to comments in file fs/ocfs2/cluster/quorum.c:70 about the  
self-fencing operations :

/* It should instead flip the file
?* system RO and call some userspace script. */

So, I tried to add it (but i did'nt find a way to flip the fs in RO).

Here is a proposal for this functionnality, based on ocfs2-1.4.7.
This patch add an entry 'fence_cmd' in /sys to specify an userspace  
fence script.
This behavior can be selected by echoing the new keyword 'cmd' in  
fence_method.

Example :

echo "/usr/local/sbin/my_fencer"> /sys/kernel/config/cluster/ocfs2/fence_cmd
echo "cmd"> /sys/kernel/config/cluster/ocfs2/fence_method

Hope this could interest someone.

   Nicolas AGIUS

----------------------------------------------------------------
This message was sent using IMP, the Internet Messaging Program.

-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20101209/e8648a47/attachment-0001.html 
-------------- next part --------------
A non-text attachment was scrubbed...
Name: ocfs2-fence-self-usermode.patch
Type: text/x-diff
Size: 5122 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20101209/e8648a47/attachment-0001.bin 
