From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 13 Nov 2009 14:07:15 -0800
Subject: [Ocfs2-devel] disable reboots when fencing
In-Reply-To: <DB7C4A32-5E4B-48DA-8456-CDBDD025ACEB@itec.suny.edu>
References: <DB7C4A32-5E4B-48DA-8456-CDBDD025ACEB@itec.suny.edu>
Message-ID: <20091113220714.GA9739@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Nov 13, 2009 at 11:27:08AM -0500, Hoot, Joseph wrote:
> What is the OCFS2 v1.4 equivalent to the OCFS2 v1.2 command to disable reboots upon fencing?
> 
>  echo 1 > /proc/fs/ocfs2_nodemanager/fence_method 

	The big question is why you want this.  You are opening your
systems up to data corruption, which is a very bad thing.

Joel

-- 

"In the beginning, the universe was created. This has made a lot 
 of people very angry, and is generally considered to have been a 
 bad move."
        - Douglas Adams

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
