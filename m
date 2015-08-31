From: Mark Fasheh <mfasheh@suse.de>
Date: Mon, 31 Aug 2015 12:54:33 -0700
Subject: [Ocfs2-devel] [patch 16/28] ocfs2: use 64bit variables to track
	heartbeat time
In-Reply-To: <55de39b3.bvLYc7Hlsn6Fm6Py%akpm@linux-foundation.org>
References: <55de39b3.bvLYc7Hlsn6Fm6Py%akpm@linux-foundation.org>
Message-ID: <20150831195433.GV1145@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Aug 26, 2015 at 03:12:03PM -0700, Andrew Morton wrote:
> From: Tina Ruchandani <ruchandani.tina@gmail.com>
> Subject: ocfs2: use 64bit variables to track heartbeat time
> 
> o2hb_elapsed_msecs computes the time taken for a disk heartbeat.  'struct
> timeval' variables are used to store start and end times.  On 32-bit
> systems, the 'tv_sec' component of 'struct timeval' will overflow in year
> 2038 and beyond.
> 
> This patch solves the overflow with the following:
> 
> 1. Replace o2hb_elapsed_msecs using 'ktime_t' values to measure start
>    and end time, and built-in function 'ktime_ms_delta' to compute the
>    elapsed time.  ktime_get_real() is used since the code prints out the
>    wallclock time.
> 
> 2. Changes format string to print time as a single 64-bit nanoseconds
>    value ("%lld") instead of seconds and microseconds.  This simplifies
>    the code since converting ktime_t to that format would need expensive
>    computation.  However, the debug log string is less readable than the
>    previous format.
> 
> Signed-off-by: Tina Ruchandani <ruchandani.tina@gmail.com>
> Suggested by: Arnd Bergmann <arnd@arndb.de>
> Cc: Mark Fasheh <mfasheh@suse.com>
> Cc: Joel Becker <jlbec@evilplan.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Reviewed-by: Mark Fasheh <mfasheh@suse.de>

--
Mark Fasheh
