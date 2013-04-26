From: Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 26 Apr 2013 12:06:44 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2/dlm: Remove redundant null
 pointer check
In-Reply-To: <20130426175159.GQ24720@wotan.suse.de>
References: <1366973262-2730-1-git-send-email-sachin.kamat@linaro.org>
	<20130426175159.GQ24720@wotan.suse.de>
Message-ID: <20130426120644.16b4d7d42317037e8bec6a38@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, 26 Apr 2013 10:51:59 -0700 Mark Fasheh <mfasheh@suse.de> wrote:

> This seems entirely reasonable.
> 
> On Fri, Apr 26, 2013 at 04:17:42PM +0530, Sachin Kamat wrote:
> > kfree on a NULL pointer is a no-op. Hence remove the redundant null
> > pointer check.
> > 
> > Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> 
> Signed-off-by: Mark Fasheh <mfasheh@suse.de>
> 	--Mark

For some reason I didn't receive the original email.  Resend, please?
