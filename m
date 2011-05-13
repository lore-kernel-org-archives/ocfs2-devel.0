From: Goldwyn Rodrigues <rgoldwyn@gmail.com>
Date: Fri, 13 May 2011 08:28:04 -0500
Subject: [Ocfs2-devel] ocfs2 crashes on xfstest 013
In-Reply-To: <4DCBD469.3090201@oracle.com>
References: <BANLkTi=VjeRc_6t-4vmCxpvwRAxCYjB_KA@mail.gmail.com>
	<4DCBD469.3090201@oracle.com>
Message-ID: <BANLkTimwERrLio8N6d-JrR9KJgQgv3NQCw@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Tristan,

On Thu, May 12, 2011 at 7:36 AM, Tristan Ye <tristan.ye@oracle.com> wrote:
> Hi Goldwyn,
> ? ? ? ?The root cause was due to we didn't skip an existing hole somewhere when
> punching a hole, to speak more accurately, the bug occurs at the time when we
> removing a partial extent record(which also means the last extent record to
> remove), as a result, the hole-punching code attempts to remove more than the
> length of whole extent record, which leads to the failure of following
> assert(fs/ocfs2/alloc.c):
>
> 5507 ? ? ? ? BUG_ON(cpos < le32_to_cpu(rec->e_cpos) || trunc_range > rec_range);
>
> ? ? ? ?Could you please make a verification against my coming patch, I passed xfs's
> 013 testcase with the patch;-)
>

Did you post this patch? ... or am I being impatient?

-- 
Goldwyn
