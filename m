From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 2 Jan 2006 03:21:39 -0800
Subject: [Ocfs2-devel] [PATCH] make really clean in ocfs2-tools/extras
In-Reply-To: <43B8FBA7.1050707@ubuntu.com>
References: <43B8FBA7.1050707@ubuntu.com>
Message-ID: <20060102112139.GA18439@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Jan 02, 2006 at 11:08:39AM +0100, Fabio Massimo Di Nitto wrote:
> almost a cosmetic patch :)
> 
> could you please apply it?

	Aha, no we can't.  UNINST_PROGRAMS exists expressly because you
don't want them in BIN_PROGRAMS.  If they are in BIN_PROGRAMS, they get
installed by "make install", which we don't want.
	The right answer, of course, is that "make clean" should be
removing UNINST_PROGRAMS.  I'll look into it.
	(Cc'ing ocfs2-tools-devel, which is where I should have asked
you to post :-)

Joel

-- 

"I don't want to achieve immortality through my work; I want to
 achieve immortality through not dying."
        - Woody Allen

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
