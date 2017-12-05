From: Arnd Bergmann <arnd@arndb.de>
Date: Tue, 5 Dec 2017 21:27:08 +0100
Subject: [Ocfs2-devel] [PATCH] ocfs2: use get_task_comm
In-Reply-To: <CAGXu5j+=7wAsJpUwAsPK_AMzhLduhBGpdQm9oqqbt3bzoQOMDQ@mail.gmail.com>
References: <20171205152110.2050975-1-arnd@arndb.de>
	<CAGXu5j+=7wAsJpUwAsPK_AMzhLduhBGpdQm9oqqbt3bzoQOMDQ@mail.gmail.com>
Message-ID: <CAK8P3a0RYJwyOui+dP-QJSJh3JVZ+XGLKSV3B6hVBr78nptDRQ@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kees Cook <keescook@chromium.org>
Cc: Mark Fasheh <mfasheh@versity.com>, Joel Becker <jlbec@evilplan.org>, Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Joseph Qi <jiangqi903@gmail.com>, piaojun <piaojun@huawei.com>, ocfs2-devel@oss.oracle.com, LKML <linux-kernel@vger.kernel.org>

On Tue, Dec 5, 2017 at 8:19 PM, Kees Cook <keescook@chromium.org> wrote:
> On Tue, Dec 5, 2017 at 7:20 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>> While reviewing all callers of get_task_comm(), I stumbled
>> over this one that claimed it was not exported, when in fact
>> it is. Accessing task->comm directly is not safe, so better
>> convert this one to using get_task_comm as well.
>
> Using get_task_comm() in cases like this is actually overkill (i.e.
> using up stack space), since there's (currently) no benefit. Nothing
> protects getting a "correct" view of task->comm (i.e. it could get
> updated in the middle of a copy), but it _is_ always NULL terminated,
> so it's safe to use with %s like this. While it does make me slightly
> uncomfortable to _depend_ on this NULL termination, but there are lots
> of open-coded %s users of task->comm. When we're trying to save a
> _copy_ of task->comm, then we want get_task_comm(), just to make sure
> we're doing it right.
>
> So, while I don't oppose this patch, it might be seen as a wasteful
> use of stack space.

It's only a few bytes of stack space in a leaf function, I'd not be
worried about that.

More generally speaking though, how exactly do we guarantee that
there is NUL-termination on tsk->comm during a concurrent update?
Could we ever get into a situation where overwrite the NUL byte
while setting tsk->comm to a longer string, and read the new start
of the string together with an unterminated end, or do we strictly
guarantee that the last byte is still NUL? I assume the latter is
true, just haven't found exactly where that guarantee is made.

      Arnd
