From: Tao Ma <tao.ma@oracle.com>
Date: Thu, 30 Oct 2008 21:45:59 +0800
Subject: [Ocfs2-devel] [PATCH 00/15] ocfs2: add security EA and ACL
 support V4
In-Reply-To: <49099B13.9030802@oracle.com>
References: <49099B13.9030802@oracle.com>
Message-ID: <4909BA97.6090501@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Tiger Yang wrote:
> hi,
> This is the version 4 patches for add security EA and ACL support in 
> ocfs2. We have fixed many problems in version 3 and I split the previous 
> big patch into some small patches. Them based on joel's xattr_buckets 
> branch.
>
> The first five patches from Tao Ma.
> 1: only extend xattr bucket in need
> 2: add cluster free in dealloc ctxt
> 3: move clusters free into dealloc
> 4: reserve meta data at the begining of ocfs2_xattr_set
> 5: merge xattr set transactions
>   
One more thing. These patches are based on Joel's xattr-buckets branch.
Joel, please review them. Thanks.

Regards,
Tao
