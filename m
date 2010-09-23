From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 23 Sep 2010 14:22:52 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: update ctime when changing the
 file's permission by setfacl
In-Reply-To: <1284357623-3113-1-git-send-email-tao.ma@oracle.com>
References: <1284357623-3113-1-git-send-email-tao.ma@oracle.com>
Message-ID: <20100923212251.GA6609@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Sep 13, 2010 at 02:00:23PM +0800, Tao Ma wrote:
> In commit 30e2bab, ext3 fixed it. So change it accordingly in ocfs2.
> 
> Steps to reproduce:
> # touch aaa
> # stat -c %Z aaa
> 1283760364
> # setfacl -m  'u::x,g::x,o::x' aaa
> # stat -c %Z aaa
> 1283760364
> 
> Signed-off-by: Tao Ma <tao.ma@oracle.com>

	This patch is now in the 'fixes' branch of ocfs2.git.

Joel

-- 

"I'm drifting and drifting
 Just like a ship out on the sea.
 Cause I ain't got nobody, baby,
 In this world to care for me."

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
