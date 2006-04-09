From: Wim Coekaerts <wim.coekaerts@oracle.com>
Date: Sat, 8 Apr 2006 21:13:38 -0700
Subject: [Ocfs2-devel] using ethernet instead of TCP
In-Reply-To: <AEC6C66638C05B468B556EA548C1A77DCEBF59@trantor>
References: <AEC6C66638C05B468B556EA548C1A77DCEBF59@trantor>
Message-ID: <20060409041337.GG21199@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

nope not yet :)

On Sun, Apr 09, 2006 at 01:56:32PM +1000, James Harper wrote:
> Has anyone considered having the option of using Ethernet instead of TCP
> for inter-node communications? Such a feature would be useful for me as
> I'd like to use the same Ethernet segment for inter-node communication
> as I run AoE over (much less chance of a split brain), but I don't
> currently run IP on that segment. Also, running ocfs2 as the root
> filesystem would be easier (I've asked on -users if this is a good idea,
> as discussion of that aspect probably isn't appropriate to -devel) as IP
> wouldn't need to be started before bringing the root filesystem online.
> 
> Obviously it's going to limit the cluster to the one lan segment, and
> you get a lot of stuff 'for free' with TCP that would have to be written
> for ocfs2 to use Ethernet (but I don't know how much the inter-node
> stuff actually makes use of it), so it might be too much work for too
> little gain...
> 
> Thanks
> 
> James
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
