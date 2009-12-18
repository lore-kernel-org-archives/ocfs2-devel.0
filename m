From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 17 Dec 2009 21:09:55 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: replace u8 by __u8 in ocfs2_fs.h
In-Reply-To: <4B1BC1FD.90803@suse.de>
References: <4B1BC1FD.90803@suse.de>
Message-ID: <20091218050954.GA20149@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Sun, Dec 06, 2009 at 10:38:53PM +0800, Coly Li wrote:
> This patch replaces date type 'u8' with '__u8', which follows the coding style of ocfs2_fs.h, and portable to user space
> for ocfs2-tools.

	This is now in ocfs2.git.

Joel

-- 

"For every complex problem there exists a solution that is brief,
     concise, and totally wrong."
                                        -Unknown

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
