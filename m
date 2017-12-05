From: Peter Zijlstra <peterz@infradead.org>
Date: Tue, 5 Dec 2017 23:01:36 +0100
Subject: [Ocfs2-devel] [PATCH] ocfs2: use get_task_comm
In-Reply-To: <CAK8P3a3Ucm587Ah57-4fKwxkJwK6RvE_4Tgdf_cnKpU6PpoZhg@mail.gmail.com>
References: <20171205152110.2050975-1-arnd@arndb.de>
	<CAGXu5j+=7wAsJpUwAsPK_AMzhLduhBGpdQm9oqqbt3bzoQOMDQ@mail.gmail.com>
	<CAK8P3a0RYJwyOui+dP-QJSJh3JVZ+XGLKSV3B6hVBr78nptDRQ@mail.gmail.com>
	<CAGXu5jL507+NhCtbQEZDbLihGAybNNkuOeettKB+9NcAg5TAPQ@mail.gmail.com>
	<CAK8P3a3Ucm587Ah57-4fKwxkJwK6RvE_4Tgdf_cnKpU6PpoZhg@mail.gmail.com>
Message-ID: <20171205220136.GW3165@worktop.lehotels.local>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Arnd Bergmann <arnd@arndb.de>
Cc: Kees Cook <keescook@chromium.org>, Mark Fasheh <mfasheh@versity.com>, Joel Becker <jlbec@evilplan.org>, Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, Joseph Qi <jiangqi903@gmail.com>, piaojun <piaojun@huawei.com>, ocfs2-devel@oss.oracle.com, LKML <linux-kernel@vger.kernel.org>

On Tue, Dec 05, 2017 at 10:44:17PM +0100, Arnd Bergmann wrote:
> On Tue, Dec 5, 2017 at 9:32 PM, Kees Cook <keescook@chromium.org> wrote:
> > On Tue, Dec 5, 2017 at 12:27 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> >>
> >> More generally speaking though, how exactly do we guarantee that
> >> there is NUL-termination on tsk->comm during a concurrent update?
> >> Could we ever get into a situation where overwrite the NUL byte
> >> while setting tsk->comm to a longer string, and read the new start
> >> of the string together with an unterminated end, or do we strictly
> >> guarantee that the last byte is still NUL? I assume the latter is
> >> true, just haven't found exactly where that guarantee is made.
> >
> > strncpy will zero pad with the trailing NULL, so it's supposed to
> > always be safe... still gives me the creeps, though.
> 
> But set_task_comm uses strlcpy(), not strncpy(), so you might
> get some of the old data back, the question is just whether it could
> leak uninitialized data or part of the task_struct up to the next
> NUL byte. I could not come up with any code path that would leave
> a non-NUL byte in at the end of task->comm though, so it's
> probably still safe.

So we used to have some magic code set_task_comm() which even included a
memory barrier etc.. But since none of the reading sites include a
memory barrier its all pointless.

There is no guarantee that a tsk->comm user reads the bytes in string
order.

The only thing that ensures we never run over, is the hard guarantee
that ->comm[TSK_COMM_LEN-1] == 0 at all times. If we don't trust
str*cpy() to do the right thing here, we could simply open code the
thing.
