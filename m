From: Christoph Hellwig <hch@lst.de>
Date: Thu Oct 14 13:50:35 2004
Subject: [Ocfs2-devel] Re: [Ocfs2-commits] bryce commits r1573 - in trunk: .
	mount.ocfs
In-Reply-To: <200410141425.i9EEPDZS029376@oss.oracle.com>
References: <200410141425.i9EEPDZS029376@oss.oracle.com>
Message-ID: <20041014185029.GA31796@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

> +int module_loaded(char * module) {
> +	int fd;
> +	int i;
> +	char line[100];
> +
> +	if ((fd = open("/proc/modules", O_RDONLY)) >= 0 ) {
> +                        while ((i = read(fd, line, 100)) > 0) {
> +                                if (strstr(line, module) != 0) {
> +					close(fd);
> +					return (1);
> +				}
> +                        close(fd);
> +                        return (0);
> +                }
> +	}
> +}

this check is bogus, the kernel will autload a filesystem on the first
mount attempt.
