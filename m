From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 11 May 2009 13:49:24 -0700
Subject: [Ocfs2-devel] [RFC] The reflink(2) system call v2.
In-Reply-To: <4A039FF8.7090807@hp.com>
References: <1241331303-23753-1-git-send-email-joel.becker@oracle.com>
	<20090507221535.GA31624@mail.oracle.com> <4A039FF8.7090807@hp.com>
Message-ID: <20090511204924.GC30293@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: jim owens <jowens@hp.com>
Cc: jmorris@namei.org, linux-security-module@vger.kernel.org, mtk.manpages@gmail.com, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

On Thu, May 07, 2009 at 10:59:04PM -0400, jim owens wrote:
> - fix the
> +	if (S_ISDIR(inode->i_mode))
> +		return -EPERM;
>
>   to be an ISREG check unless you have an argument for
>   special files and symlinks being COWed.

	I'm unsure on this one, and would like other comments.  Why?  It
doesn't *hurt* to allow reflink on symlinks or special files.  Mostly
it's a waste - symlinks may have a data extent, but special files do
not.  But I'm not sure there's a point to arbitrarily limit filesystems
when there's nothing we're combating.
	Jim, if you have a real problem this prevents, I'm all ears.
And if others concur that restricting it to regular files is the right
way to go, I can be convinced.

Joel

-- 

"Hey mister if you're gonna walk on water,
 Could you drop a line my way?"

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
