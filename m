From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon Aug  2 13:46:10 2004
Subject: [Ocfs2-devel] Calculating volume size from superblock
In-Reply-To: <60C14C611F1DDD4198D53F2F43D8CA3B01812211@orsmsx410>
References: <60C14C611F1DDD4198D53F2F43D8CA3B01812211@orsmsx410>
Message-ID: <20040802184605.GJ2595@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Aug 02, 2004 at 11:13:46AM -0700, Villalovos, John L wrote:
> How do I calculate the size of the volume from the superblock?
> 
> Do I just use the two fields:
> 
> u_int32_t s_blocksize_bits;         /* Blocksize for this fs */
> u_int32_t s_clustersize_bits;       /* Clustersize for this fs */
> 
> What is the formula to use?

	As Sunil pointed out, you need to use the global bitmap to
determine the number of clusters and multiply it by the clustersize.
The libocfs2 library can help you get that information, or you can code
up the bits to parse the information yourself.  Doing it yourself means
learning how to navigate directories.

Joel

-- 

"Sometimes I think the surest sign intelligent
 life exists elsewhere in the universe is that
 none of it has tried to contact us."
                                -Calvin & Hobbes

Joel Becker
Senior Member of Technical Staff
Oracle Corporation
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
