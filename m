From: Sunil Mushran <Sunil.Mushran@oracle.com>
Date: Mon Aug  9 12:54:18 2004
Subject: [Ocfs2-devel] Cluster sizes allowed?
In-Reply-To: <60C14C611F1DDD4198D53F2F43D8CA3B0194AA20@orsmsx410>
References: <60C14C611F1DDD4198D53F2F43D8CA3B0194AA20@orsmsx410>
Message-ID: <1092073703.9393.12.camel@smushran-pc1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Yes.

4K, 8K, 16K, 32K, 64K, 128K, 256K, 512K, 1M

On Mon, 2004-08-09 at 10:13, Villalovos, John L wrote:
> Another quick question.
> 
> What are the cluster sizes allowed?
> 
> I was thinking that the formula is:
> 
> Cluster Size = 4096 * ( 2 ** X ) where 0 <= X <= 8.
> 
> Is this correct?
> 
> Thanks,
> John
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel@oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
