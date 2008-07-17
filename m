From: Mark Fasheh <mfasheh@suse.com>
Date: Thu, 17 Jul 2008 11:13:10 -0700
Subject: [Ocfs2-devel] [PATCH 08/15] ocfs2: Add extended attribute
	support v2
In-Reply-To: <487F1209.6050204@oracle.com>
References: <48648B3E.6050808@oracle.com>
	<1214551656-22529-1-git-send-email-tiger.yang@oracle.com>
	<1214551656-22529-2-git-send-email-tiger.yang@oracle.com>
	<20080710231119.GB32459@wotan.suse.de>
	<487F1209.6050204@oracle.com>
Message-ID: <20080717181310.GJ28014@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Jul 17, 2008 at 05:34:01PM +0800, Tiger Yang wrote:
> >Btw, neither this, nor any of the other code seems to take symlinks into
> >account. As far as I can tell, it's valid to set xattrs on a symlink. Is
> >this correct? If so, we need to handle fast symlinks and also symlinks with
> >extents. Though I suppose symlinks using extents probably don't need any
> >extra work since they otherwise look like regular files.
> 
> Could I do not put xattr inline when I found its a fast symlink? This 
> could make the question simple.

Most of our symlinks are fast symlinks, so I don't think it'd be a good idea
to skip inline xattrs on them.

What's the problem though? From your code, it seemed like fast symlinks
would be pretty easy to take care of... Keep in mind by the way, that once
created, the contents of a symlink never change. So it's not like you'll
have to update the actual symlink code very much.
	--Mark

--
Mark Fasheh
