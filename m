From: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 8 Jan 2018 17:23:49 -0800
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2: make metadata estimation
	accurate and clear
In-Reply-To: <63ADC13FD55D6546B7DECE290D39E373F290CEEE@H3CMLB12-EX.srv.huawei-3com.com>
References: <63ADC13FD55D6546B7DECE290D39E373F290CEEE@H3CMLB12-EX.srv.huawei-3com.com>
Message-ID: <20180108172349.da537610c561ee7cfd6969e8@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, 8 Jan 2018 01:36:05 +0000 Changwei Ge <ge.changwei@h3c.com> wrote:

> Current code assume that ::w_unwritten_list always has only one item on.
> This is not right and hard to get understood.
> So improve how to count unwritten item.

I get a large number of patch rejects applying this (and patch 2) to
current mainline.  What kernel version are these against?
