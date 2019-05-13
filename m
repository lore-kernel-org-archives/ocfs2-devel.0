From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Mon, 13 May 2019 09:14:52 +0200
Subject: [Ocfs2-devel] [PATCH] ocfs2: Fix error path kobject memory leak
In-Reply-To: <20190513033458.2824-1-tobin@kernel.org>
References: <20190513033458.2824-1-tobin@kernel.org>
Message-ID: <20190513071452.GG2868@kroah.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Tobin C. Harding" <tobin@kernel.org>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, "Rafael J. Wysocki" <rafael@kernel.org>, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

On Mon, May 13, 2019 at 01:34:58PM +1000, Tobin C. Harding wrote:
> If a call to kobject_init_and_add() fails we should call kobject_put()
> otherwise we leak memory.
> 
> Add call to kobject_put() in the error path of call to
> kobject_init_and_add().  Please note, this has the side effect that
> the release method is called if kobject_init_and_add() fails.
> 
> Signed-off-by: Tobin C. Harding <tobin@kernel.org>
> ---

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
