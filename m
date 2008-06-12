From: Louis Rilling <Louis.Rilling@kerlabs.com>
Date: Fri, 13 Jun 2008 00:38:03 +0200
Subject: [Ocfs2-devel] [RFC] configfs: Allow ->make_item() and
	->make_group() to	return detailed errors.
In-Reply-To: <1213305595-16805-1-git-send-email-joel.becker@oracle.com>
References: <1213305595-16805-1-git-send-email-joel.becker@oracle.com>
Message-ID: <20080612223803.GB4012@localdomain>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel Becker <joel.becker@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, cluster-devel@redhat.com, teigland@redhat.com

On Thu, Jun 12, 2008 at 02:19:55PM -0700, Joel Becker wrote:
> The configfs operations ->make_item() and ->make_group() currently
> return a new item/group.  A return of NULL signifies an error.  Because
> of this, -ENOMEM is the only return code bubbled up the stack.
> 
> Multiple folks have requested the ability to return specific error codes
> when these operations fail.  This patch adds that ability by changing the
> ->make_item/group() ops to return an int.
> 
> Also updated are the in-kernel users of configfs.
> 
> Signed-off-by: Joel Becker <joel.becker@oracle.com>

Looks good to me. Happy to see this change coming :)

Louis

-- 
Dr Louis Rilling			Kerlabs - IRISA
Skype: louis.rilling			Campus Universitaire de Beaulieu
Phone: (+33|0) 2 99 84 71 52		Avenue du General Leclerc
Fax: (+33|0) 2 99 84 71 71		35042 Rennes CEDEX - France
http://www.kerlabs.com/
