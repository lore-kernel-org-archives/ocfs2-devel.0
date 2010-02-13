From: Joel Becker <Joel.Becker@oracle.com>
Date: Sat, 13 Feb 2010 15:04:12 -0800
Subject: [Ocfs2-devel] ocfs2 compile error in x86_64
In-Reply-To: <b84722ce1002122039u78453746xc66f83fdd22fa3f1@mail.gmail.com>
References: <b84722ce1002122039u78453746xc66f83fdd22fa3f1@mail.gmail.com>
Message-ID: <20100213230412.GA8207@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Sat, Feb 13, 2010 at 11:39:01AM +0700, satit pherm wrote:
> I tried to compiled ocfs2 on 2.6.32.2 x86_64 but still failed.
> there are an error blow:

	This is ocfs2-tools, not ocfs2.  But your problem is that
com_err can't really be built statically anymore.  You want to configure
with --enable-dynamic-fsck and --enable-dynamic-ctl

Joel

-- 

"Every day I get up and look through the Forbes list of the richest
 people in America. If I'm not there, I go to work."
        - Robert Orben

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
