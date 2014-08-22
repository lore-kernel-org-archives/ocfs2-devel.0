From: Sunil Mushran <sunil.mushran@gmail.com>
Date: Fri, 22 Aug 2014 10:08:43 -0700
Subject: [Ocfs2-devel] A deadlock when system do not has sufficient
	memory
In-Reply-To: <53F6FFB7.1090305@huawei.com>
References: <53F41CAE.2040204@huawei.com> <53F6FFB7.1090305@huawei.com>
Message-ID: <CAEeiSHVP60=zNcP-Q2bCD_BdD3g8v1a__Vyn4ZMF_8Z97cpE8g@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Allocs made via GFP_NOFS, by definition, should not trigger any reclaim
from the fs.
So this situation should never arise. That's why all allocs in the dlm have
NOFS.
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20140822/67094873/attachment.html 
