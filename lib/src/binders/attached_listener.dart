part of databinder;

class _AttachedListener {
  h.EventListenerList list;
  h.EventListener listener;

  _AttachedListener(this.list, this.listener);

  deattach(){
    list.remove(listener);
  }

  attach(){
    list.add(listener);
  }
}