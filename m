From: Rusty Lynch <rusty@linux.co.intel.com>
Date: Thu Mar  4 13:50:13 2004
Subject: [Ocfs2-devel] 2.6 status
In-Reply-To: <20040304182631.GF5856@ca-server1.us.oracle.com>
References: <20040304182631.GF5856@ca-server1.us.oracle.com>
Message-ID: <20040304195000.GA28812@penguin.co.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Mar 04, 2004 at 10:26:31AM -0800, Wim Coekaerts wrote:
> so I need to send something that at least builds to suse today or
> tomorrow(absolute latest) for 2.6, can I ? 

The current tree can do this now. You can load the module, mount 
the file system, and then die in various ways.

I just figured out what was missing in the inode creation / adding
a new hash entry/ binding the the new inode process, and will 
have a patch out today that will make the file system usable
(well, until you try to delete something :->)

John has access to the latest SLES9 beta, and is working on a spec
file.

    --rusty
