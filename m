From: Zach Brown <zach.brown@oracle.com>
Date: Fri Dec  1 10:45:30 2006
Subject: [Ocfs2-devel] [patch 3/3] ocfs2-timeout-protocol.patch
In-Reply-To: <20061201082748.031459000@suse.de>
References: <20061201082328.841791000@suse.de>
	<20061201082748.031459000@suse.de>
Message-ID: <45707647.4010006@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


> +	if(unlikely(sc->sc_handshake_ok == 0)) {
> +		if(sc->sc_page_off < sizeof(struct o2net_handshake)) {
> +			data = page_address(sc->sc_page) + sc->sc_page_off;
> +			datalen = sizeof(struct o2net_handshake) - sc->sc_page_off;
> +			ret = o2net_recv_tcp_msg(sc->sc_sock, data, datalen);
> +			if (ret > 0)
> +				sc->sc_page_off += ret;
> +		}
> +
> +		if (sc->sc_page_off == sizeof(struct o2net_handshake)) {
> +			o2net_check_handshake(sc);
> +		}
> +
> +		if(unlikely(sc->sc_handshake_ok == 0)) {
> +			goto out;
> +		}
> +	}

Has this been tested with a case where check_handshake() fails?  I
wonder if it will result in multiple messages because it doesn't return
an error when check_handshake fails.

The first time through it will queue disconnect work and print out the
message.  but it'll return +ve bytes read.  We'll come back into the
loop again, check the handshake again, but this time return 0 because no
bytes were read.  At that point   _rx_until_empty will stop retrying.

Am I missing something?

Otherwise it looks fine.

- z
