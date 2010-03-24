From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed, 24 Mar 2010 11:50:37 -0700
Subject: [Ocfs2-devel] Question of rejecting a downconvert
In-Reply-To: <201003241646.58845.dyli@novell.com>
References: <201003241646.58845.dyli@novell.com>
Message-ID: <4BAA5EFD.4040905@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

While the fs can delay the downconvert of any resource, there are
no means of explicitly rejecting it. And no rejection means the
requesting node will keep waiting for the downconvert.

Li Dongyang wrote:
> Hi, list
> I've read 
> http://opendlm.sourceforge.net/cvsmirror/opendlm/docs/dlmbook_final.pdf but 
> still confused, why a node can not reject a downconvert when it gets a bast in 
> o2dlm?
> and if we can, we could fix this bug: 
> http://oss.oracle.com/bugzilla/show_bug.cgi?id=1075
> ocfs2: a busy mount point can be removed from another node
> by adding a check in check_downconvert callback:
> if the dentry->d_mounted is not zero, then just reject the downconvert.
>
> Any hints? :-)
> Thanks
>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
>   
