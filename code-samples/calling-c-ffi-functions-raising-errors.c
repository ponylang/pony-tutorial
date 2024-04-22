// In pony.h
PONY_API void pony_error();

// In socket.c
PONY_API size_t pony_os_send(asio_event_t* ev, const char* buf, size_t len)
{
  ssize_t sent = send(ev->fd, buf, len, 0);

  if(sent < 0)
  {
    if(errno == EWOULDBLOCK || errno == EAGAIN)
      return 0;

    pony_error();
  }

  return (size_t)sent;
}