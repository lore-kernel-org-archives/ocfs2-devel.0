From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Mon Mar  1 17:43:05 2004
Subject: [Ocfs2-devel] [PATCH]2.6 fixes in journal.c
In-Reply-To: <20040301223627.GA22544@penguin.co.intel.com>
References: <200402270216.i1R2GnW8007425@penguin.co.intel.com>
	<20040301165447.GA16000@penguin.co.intel.com>
	<20040301223627.GA22544@penguin.co.intel.com>
Message-ID: <20040301234301.GV1421@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Mar 01, 2004 at 02:36:27PM -0800, Rusty Lynch wrote:
> The following patch addes #if LINUX_VERSION_CODE wrappers around the
> journal_get_write_access() call, and drops the journal locking calls for
> both the 2.4 and 2.6 code when the commit interval is set durring journal
> initialization.
Alright, committed.
	--Mark

--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
