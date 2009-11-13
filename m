From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 12 Nov 2009 18:27:28 -0800
Subject: [Ocfs2-devel] [PATCH 17/18] ocfs2: Handle missing
 filemap_fdatawait_range()
In-Reply-To: <1258076859-13538-18-git-send-email-sunil.mushran@oracle.com>
References: <1258076859-13538-1-git-send-email-sunil.mushran@oracle.com>
	<1258076859-13538-18-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20091113022727.GB21197@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Nov 12, 2009 at 05:47:38PM -0800, Sunil Mushran wrote:
> Mainline commit 918941a3f3d46c2a69971b4718aaf13b1be2f1a7 replaced
> generic_file_aio_write_nolock() with __generic_file_aio_write()
> and made use of helpers filemap_fdatawrite_range() and filemap_fdatawait_range().
> 
> Patch adds macros to allow building with current and older EL5 kernels.

	Ok, if I remember correctly, the old
generic_file_aio_write_nlock() would do the sync work for us.  Please
add a comment in filemap_fdatawait_range.h about this so people don't
worry that the define becomes 0.

Joel

-- 

"Drake!  We're LEAVING!"

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
