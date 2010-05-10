From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 10 May 2010 12:47:44 -0700
Subject: [Ocfs2-devel] [PATCH 0/4] Patches series for optimization of
 truncating and punching-hole.
In-Reply-To: <4BE26A10.3070606@oracle.com>
References: <4BE26A10.3070606@oracle.com>
Message-ID: <20100510194744.GB2836@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, May 06, 2010 at 03:04:48PM +0800, tristan wrote:
> Following 4 patches are the entire patches series of truncating and 
> punching-holes atop your latest merge-window branch.
> 
> And it survived all my testcases on hand.

Tristan,
	Thank you for sending the new series.  It looks good
functionally.  I replied to the first patch with a couple of cleanups.
	Please use the --compose option to git-send-email to create your
[PATCH 0/x] emails.  This makes them thread in our mailboxes better ;-)
	Mark, can I get your evaluation of this patch series before I
push it to merge-window?

Joel

-- 

"You don't make the poor richer by making the rich poorer."
	- Sir Winston Churchill

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
