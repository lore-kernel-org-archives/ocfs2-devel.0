From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 10 Nov 2009 19:03:35 -0800
Subject: [Ocfs2-devel] [PATCH 07/10] ocfs2: Handle struct f_path in
 struct file
In-Reply-To: <1257818413-32014-8-git-send-email-sunil.mushran@oracle.com>
References: <1257818413-32014-1-git-send-email-sunil.mushran@oracle.com>
	<1257818413-32014-8-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20091111030334.GD17774@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Nov 09, 2009 at 06:00:10PM -0800, Sunil Mushran wrote:
> Mainline commit 0f7fc9e4d03987fe29f6dd4aa67e4c56eb7ecb05 added
> struct path into struct file.

	Again, put #ifndef filp_dentry() in fs/ocfs2/kapi-defaults.h and
only include kapi-include/fpath.h if necessary.

Joel

-- 

"Get right to the heart of matters.
 It's the heart that matters more."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
