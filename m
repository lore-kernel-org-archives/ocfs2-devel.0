From: Joe Perches <joe@perches.com>
Date: Tue, 22 Oct 2013 23:58:33 -0000
Subject: [Ocfs2-devel] [PATCH 00/24] treewide: Convert use of typedef
 ctl_table to struct ctl_table
In-Reply-To: <52670FF4.8070701@gmail.com>
References: <cover.1382480758.git.joe@perches.com> <52670FF4.8070701@gmail.com>
Message-ID: <1382486304.2041.103.camel@joe-AO722>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-arm-kernel@lists.infradead.org

On Tue, 2013-10-22 at 16:53 -0700, David Daney wrote:
> After all this work, why not go ahead and remove the typedef?  That way 
> people won't add more users of this abomination.

Hi David.

The typedef can't be removed until all the uses are gone.

I've sent this before as a single large patch as well as
individual patches.

treewide:	https://lkml.org/lkml/2013/7/22/600
RemoveTypedef:	https://lkml.org/lkml/2013/7/22/603
