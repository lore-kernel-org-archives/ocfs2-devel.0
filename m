From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed Aug 11 15:36:27 2004
Subject: [Ocfs2-devel] data inconsistency when write in a memory map way
In-Reply-To: <B44D37711ED29844BEA67908EAF36F038AD04A@pdsmsx401.ccr.corp.intel.com>
References: <B44D37711ED29844BEA67908EAF36F038AD04A@pdsmsx401.ccr.corp.intel.com>
Message-ID: <20040811203623.GB2595@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Aug 11, 2004 at 05:38:10PM +0800, Chen, Yukun wrote:
> 1.on node a, write to a file residing on a ocfs2 partition in a way of
> memory 
> 
> map
> 
> 2.then on node b , check the writtent data but nothing will be found.

	Try using msync() on the memory map after writing to it.

Joel

-- 

 "I'm living so far beyond my income that we may almost be said
 to be living apart."
         - e e cummings

Joel Becker
Senior Member of Technical Staff
Oracle Corporation
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
