From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 24 Nov 2008 14:30:46 -0800
Subject: [Ocfs2-devel] [Patch 1/3] ocfs2-tools: Resolve rpmlint	warnings
	in init scripts
In-Reply-To: <20081124221940.GD26470@mail.oracle.com>
References: <B7D332FF-F786-4DBD-862D-8ED8CCE441A9@suse.de>
	<20081118230312.GB10451@mail.oracle.com>
	<1BC14041-8A8F-40BA-821C-FA838C774CD7@suse.de>
	<20081124221940.GD26470@mail.oracle.com>
Message-ID: <20081124223046.GE26470@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Nov 24, 2008 at 02:19:40PM -0800, Joel Becker wrote:
> 	rpmlint is wrong here, as it is tracking a SuSE-only behavior.
> At least, I can't find a RHEL system that behaves different from LSB.

	Actually, rpmlint is always wrong.  An empty -Stop line is valid
on sles11 as well - it just means "the same as -Start".

Joel

-- 

"Behind every successful man there's a lot of unsuccessful years."
        - Bob Brown

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
