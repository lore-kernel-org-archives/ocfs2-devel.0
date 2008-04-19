From: Tao Ma <tao.ma@oracle.com>
Date: Sat, 19 Apr 2008 11:42:22 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: Allow uid/gid/perm changes of
 symlinks
In-Reply-To: <20080418173513.GM31299@wotan.suse.de>
References: <1208539433-29475-1-git-send-email-sunil.mushran@oracle.com>
	<20080418173513.GM31299@wotan.suse.de>
Message-ID: <48096A1E.8050200@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Mark,
	I have read all the materials. Just curious about why ocfs2 super block 
don't support ->dirty_inode like ext3 does. If we support it and call 
ocfs2_make_inode_dirty in it, it should be OK. So is there any reason 
why we don't support ->dirty_inode?
Thanks.

Regards,
Tao

Mark Fasheh wrote:
> On Fri, Apr 18, 2008 at 10:23:53AM -0700, Sunil Mushran wrote:
>> This patch adds the ability to change attributes of a symlink.
>> Fixes oss bugzilla#963
>> http://oss.oracle.com/bugzilla/show_bug.cgi?id=963
> 
> Ok, that looks good - thanks.
> 	--Mark
> 
> --
> Mark Fasheh
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
