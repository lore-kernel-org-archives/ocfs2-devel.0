From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Thu Mar 18 12:31:22 2004
Subject: [Ocfs2-devel] A patch to fix bug 45 in bugzilla
In-Reply-To: <20040318151045.GA25973@penguin.co.intel.com>
References: <40596BF0.8020807@intel.com>
	<20040318151045.GA25973@penguin.co.intel.com>
Message-ID: <20040318183106.GN20057@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Mar 18, 2004 at 07:10:45AM -0800, Rusty Lynch wrote:
> If this is jbd bug, then how come ext3 doesn't trigger buffer_error()?
Ext3 almost never uses journal_create. They have their mkfs make the
journals for them. (journal_create is used to format a new journal)
	--Mark

--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
