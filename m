From: Joel Becker <Joel.Becker@oracle.com>
Date: Sat, 7 Aug 2010 11:38:47 -0700
Subject: [Ocfs2-devel] [PATCH 1/1 v2] ocfs2: do not overwrite error
 codes in ocfs2_init_acl
In-Reply-To: <4C3FE99E.9040504@oracle.com>
References: <4C3FE99E.9040504@oracle.com>
Message-ID: <20100807183846.GA3699@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Jul 16, 2010 at 01:09:50PM +0800, Tiger Yang wrote:

> >From d70af04aae44afc7bd2ea40a12da03a08fd3e5c1 Mon Sep 17 00:00:00 2001
> From: Tiger Yang <tiger.yang@oracle.com>
> Date: Fri, 16 Jul 2010 11:21:23 +0800
> Subject: [PATCH 1/1 v2] ocfs2: do not overwrite error codes in ocfs2_init_acl
> 
> Setting the acl while creating a new inode depends on
> the error codes of posix_acl_create_masq. This patch fix
> a issue of overwriting the error codes of it.
> 
> Reported-by: Pawel Zawora <pzawora@gmail.com>
> Cc: <stable@kernel.org> [ .33, .34 ]
> Signed-off-by: Tiger Yang <tiger.yang@oracle.com>

This patch is now in the fixes branch of ocfs2.git.

Joel

-- 

"Up and down that road in our worn out shoes,
 Talking bout good things and singing the blues."

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
