From: Mark Fasheh <mfasheh@suse.com>
Date: Wed, 31 Mar 2010 18:34:15 -0700
Subject: [Ocfs2-devel] Fix for online resize with metaecc
In-Reply-To: <20100401013021.GG28680@mail.oracle.com>
References: <20100401013021.GG28680@mail.oracle.com>
Message-ID: <20100401013415.GK11402@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Mar 31, 2010 at 06:30:21PM -0700, Joel Becker wrote:
> Mark figured out what happened with bug 1214 - online resize writes out
> the superblocks without calculating metaecc.  Here's a patch to fix it.
> 
> Tao, Tiger, Tristan... Can one of you test this quickly?

You can add my ack: Acked-by: Mark Fasheh <mfasheh@suse.com>

--
Mark Fasheh
