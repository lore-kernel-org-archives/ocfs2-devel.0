From: Wim Coekaerts <wim.coekaerts@oracle.com>
Date: Tue Jun  8 01:49:10 2004
Subject: [Ocfs2-devel] Is this bug?
In-Reply-To: <3ACA40606221794F80A5670F0AF15F840492FB1C@pdsmsx403>
References: <3ACA40606221794F80A5670F0AF15F840492FB1C@pdsmsx403>
Message-ID: <20040608064712.GA13731@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

definitely bug

On Tue, Jun 08, 2004 at 02:44:22PM +0800, Ling, Xiaofeng wrote:
> I mount a ocfs2 on two node,  when I create a directory in one node's
> ocfs root,
> I can not see it from another node at once. Until I create another
> directory on the seconds node,
> then I can see both the one create on first node and the one create on
> local.
> But when I tried the same thing in a subdiretory, this did not happen. I
> can see at once from another node.
> Not sure whether it is bug or designed so?
> Process:
> Node A:
> mkdir /ocfs/foo
> Node B:
> ls /ocfs
> output >nothing
> Node B:
> mkdir /ocfs/foo2
> ls /ocfs
> output> foo foo2
> 
> 
> 
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel@oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
