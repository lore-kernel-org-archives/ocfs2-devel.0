From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 12 Aug 2010 02:31:41 -0700
Subject: [Ocfs2-devel] [PATCH 1/2] fs/ocfs2/dlm: Eliminate update of
 list_for_each_entry loop cursor
In-Reply-To: <Pine.LNX.4.64.1008120735200.16027@ask.diku.dk>
References: <Pine.LNX.4.64.1008071108540.5821@ask.diku.dk>
	<20100812000355.GA7195@mail.oracle.com>
	<Pine.LNX.4.64.1008120735200.16027@ask.diku.dk>
Message-ID: <20100812093141.GA6561@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Julia Lawall <julia@diku.dk>
Cc: Mark Fasheh <mfasheh@suse.com>, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, Sunil Mushran <sunil.mushran@oracle.com>

On Thu, Aug 12, 2010 at 07:46:13AM +0200, Julia Lawall wrote:
 
> This seems a bit ugly to me, since it exposes the implementation of the 
> list abstraction.  What about the following:

	Actually, we're going to go back to the original list_for_each()
and list_entry() version.  It's a well understood idiom.
	We're also going to re-audit the rest of the patch that changed
list_for_each() to list_for_each_entry(), just in case we missed another
semantic error.

Joel

-- 

Life's Little Instruction Book #30

	"Never buy a house without a fireplace."

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
