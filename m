From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Mon Aug  9 13:07:49 2004
Subject: [Ocfs2-devel] Cluster sizes allowed?
In-Reply-To: <60C14C611F1DDD4198D53F2F43D8CA3B0194AA20@orsmsx410>
References: <60C14C611F1DDD4198D53F2F43D8CA3B0194AA20@orsmsx410>
Message-ID: <20040809180307.GZ8008@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Aug 09, 2004 at 10:13:11AM -0700, Villalovos, John L wrote:
> Another quick question.
> 
> What are the cluster sizes allowed?
> 
> I was thinking that the formula is:
> 
> Cluster Size = 4096 * ( 2 ** X ) where 0 <= X <= 8.
> 
> Is this correct?
Yes.
	--Mark

--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
