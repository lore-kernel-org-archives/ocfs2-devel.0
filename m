From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 11 Nov 2009 15:04:31 -0800
Subject: [Ocfs2-devel] [PATCH 08/11] ocfs2: Handle struct f_path in
 struct file
In-Reply-To: <1257972298-15590-5-git-send-email-sunil.mushran@oracle.com>
References: <1257972298-15590-1-git-send-email-sunil.mushran@oracle.com>
	<1257972298-15590-5-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20091111230431.GI17774@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Nov 11, 2009 at 12:44:57PM -0800, Sunil Mushran wrote:
> Mainline commit 0f7fc9e4d03987fe29f6dd4aa67e4c56eb7ecb05 added
> struct path into struct file.

	Again, let's describe how we did it in the commit message.  "We
wrap access with the functions filp_dentry() and filp_mnt()".  Something
like that.  It makes it clear what to look for and that filp_dentry()
isn't a kernel API, it's our wrapper.

Joel

-- 

"In the long run...we'll all be dead."
                                        -Unknown

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
