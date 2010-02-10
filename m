From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 10 Feb 2010 14:21:42 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Ignore BASTs fired after an AST
	for a drop lock]
In-Reply-To: <4B73155C.2000602@oracle.com>
References: <4B720386.7010301@oracle.com> <20100210193540.GA5062@redhat.com>
	<4B73155C.2000602@oracle.com>
Message-ID: <20100210222141.GE16310@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Feb 10, 2010 at 12:21:48PM -0800, Sunil Mushran wrote:
> So it requests NL => PR. It gets a BAST with blocking EX
> before the AST for PR. The last patch added changed the
> BAST handling to not schedule the downconvert thread if
> the current lock level was compatible. In this case, because
> the BAST is before the AST, the lock level is still NL.

	Just looking at Dave's email and thinking about what we changed,
I thought "what if the level was too low in the bast and it didn't
schedule a downconvert?".  This would require the BAST before the AST,
and sure enough, you found it.
	I agree, if the BAST is before the AST, it's a DLM bug.  You
can't be blocking a lock you don't know you have.

Joel

-- 

"Same dancers in the same old shoes.
 You get too careful with the steps you choose.
 You don't care about winning but you don't want to lose
 After the thrill is gone."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
