From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 18 Jun 2009 10:33:15 -0700
Subject: [Ocfs2-devel] [PATCH 0/2] orphan lock fixes for local mode.
In-Reply-To: <20090618172127.GA29363@mail.oracle.com>
References: <4A39F138.9050503@oracle.com>
	<20090618150645.GA7725@mail.oracle.com>
	<4A3A65EA.1060804@oracle.com>
	<20090618172127.GA29363@mail.oracle.com>
Message-ID: <4A3A7A5B.5010108@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Joel Becker wrote:
> 	Do we need the hard_readonly check like other lock types?

That too. So local and hard ro. I would prefer it in lock and
unlock also because we end up using existing code as template code.
