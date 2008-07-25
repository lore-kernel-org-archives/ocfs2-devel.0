From: Tiger Yang <tiger.yang@oracle.com>
Date: Fri, 25 Jul 2008 17:10:30 +0800
Subject: [Ocfs2-devel] [PATCH 08/15] ocfs2: Add extended attribute
 support v2
In-Reply-To: <20080710231119.GB32459@wotan.suse.de>
References: <48648B3E.6050808@oracle.com>
	<1214551656-22529-1-git-send-email-tiger.yang@oracle.com>
	<1214551656-22529-2-git-send-email-tiger.yang@oracle.com>
	<20080710231119.GB32459@wotan.suse.de>
Message-ID: <48899886.80707@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mark Fasheh wrote:
  > Btw, neither this, nor any of the other code seems to take symlinks into
> account. As far as I can tell, it's valid to set xattrs on a symlink. Is
> this correct? If so, we need to handle fast symlinks and also symlinks with
> extents. Though I suppose symlinks using extents probably don't need any
> extra work since they otherwise look like regular files.

I add ea support for symlink file and I fixed other issues you 
mentioned. please review the patch.

thanks,
tiger

-------------- next part --------------
A non-text attachment was scrubbed...
Name: 0001-ocfs2-Add-extended-attribute-support-v3.patch
Type: text/x-patch
Size: 62480 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20080725/a7750633/attachment-0001.bin 
