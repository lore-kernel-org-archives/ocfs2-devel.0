From: Tiger Yang <tiger.yang@oracle.com>
Date: Fri, 11 Jul 2008 17:39:15 +0800
Subject: [Ocfs2-devel] [PATCH 08/15] ocfs2: Add extended
 attribute	support v2
In-Reply-To: <1215742908.7387.6.camel@tristan-laptop.cn.oracle.com>
References: <48648B3E.6050808@oracle.com>	
	<1214551656-22529-1-git-send-email-tiger.yang@oracle.com>	
	<1214551656-22529-2-git-send-email-tiger.yang@oracle.com>	
	<20080710231119.GB32459@wotan.suse.de>
	<1215742908.7387.6.camel@tristan-laptop.cn.oracle.com>
Message-ID: <48772A43.9060206@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi, Tristan,

Ext3 support set xattr on symlink file, But not for user.* name space.
You can try setfattr -h -n trusted.name -v value symlinkfile and
getfattr -h -n trusted.name symlinkfile on ext3.

I will add this on our ocfs2.

Thanks,
tiger

tristan wrote:

> I agree,current VFS has exported an API lsetxattr which expects to set
> xattr on symlink directly without following it,unfortunately i did not
> see it was supported actually by ext3,and the same situation with our
> ocfs2.
